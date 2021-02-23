const STORAGE_KEY = 'node-github-redis'

const getStorage = () => {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEY)) || {}
  } catch (err) {
    return {}
  }
}

const setStorage = (storage) => {
  try {
    return localStorage.setItem(STORAGE_KEY, JSON.stringify(storage))
  } catch (err) {
    return {}
  }
}

export function storeLastNonCached (username, duration) {
  const storage = getStorage()
  
  storage[username] = duration
  
  setStorage(storage)
}


export function getLastNonCached (username) {
  const storage = getStorage()

  return storage[username]
}

export function calcTimes (username, duration) {
  const prevDuration = getLastNonCached(username)

  if (!prevDuration) {
    return ''
  }

  try {
    return Math.ceil(prevDuration / duration)
  } catch (err) {
    return ''
  }
}