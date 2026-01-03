(ns build
  (:require [clojure.tools.build.api :as b]))

(def major 0)
(def minor 0)
(def patch (format "0.0.%s" (b/git-count-revs nil)))

(def lib 'my-project/core)
(def version (format "%s.%s.%s" major minor patch))
(def class-dir "target/classes")
(def uber-file (format "target/%s-%s-standalone.jar" (name lib) version))

;; delay to defer side effects
(def basis (delay (b/create-basis {:project "deps.edn"})))

(defn clean [_]
  (b/delete {:path "target"}))

(defn uber [_]
  (clean nil)

  (b/copy-dir {:src-dirs ["src" "resources"]
               :target-dir class-dir})

  (b/compile-clj {:basis @basis
                  :ns-compile '[my-project.core]
                  :class-dir class-dir})

  (b/uber {:class-dir class-dir
           :uber-file uber-file
           :basis @basis
           :main 'my-project.core}))

